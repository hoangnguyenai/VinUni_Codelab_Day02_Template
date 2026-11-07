# Nhóm: ManchesterUnited. Nguyễn Lâm Hoàng — 26ai.hoangnl@vinuni.edu.vn.
import importlib.util
import json
import sys
from types import SimpleNamespace
from unittest.mock import MagicMock
from pathlib import Path
import pytest

spec = importlib.util.spec_from_file_location('prototype', Path(__file__).parents[1] / 'starter-code/prompt_prototype.py')
p = importlib.util.module_from_spec(spec)
spec.loader.exec_module(p)


def valid(**changes):
    data = dict(action='dispatch_mobile_charger', reason='Pin dưới ngưỡng, cần người duyệt.', requires_human_approval=True)
    data.update(changes)
    return p.PREFIX + json.dumps(data, ensure_ascii=False)


@pytest.mark.parametrize('output', [
    'text ' + valid(), valid().replace(p.PREFIX, ''), p.PREFIX + 'not json',
    p.PREFIX + '[]', p.PREFIX + '{}', valid(action='send_message'),
    valid(requires_human_approval=False), valid(requires_human_approval=1),
    valid(reason=''), valid(reason=8), valid(extra='unapproved'),
])
def test_reject_bad_contract(output):
    with pytest.raises((ValueError, TypeError)):
        p.validate_output(output)


def test_reject_wrong_decision():
    with pytest.raises(ValueError):
        p.validate_output(valid(action='review_station'), 'dispatch_mobile_charger')


def test_accept_contract():
    assert p.validate_output(valid(), 'dispatch_mobile_charger')['requires_human_approval'] is True


def test_real_sdk_wiring_mock_transport(monkeypatch):
    from google import genai
    monkeypatch.setenv('GEMINI_API_KEY', 'unit-test-not-a-real-key')
    client = MagicMock()
    client.__enter__.return_value = client
    client.models.generate_content.return_value = SimpleNamespace(text=valid()[len(p.PREFIX):])
    factory = MagicMock(return_value=client)
    monkeypatch.setattr(genai, 'Client', factory)
    output = p.evaluate_prompt('Pin 2%. Trạm 8km.')
    p.validate_output(output, 'dispatch_mobile_charger')
    args = client.models.generate_content.call_args.kwargs
    assert args['model'] == 'gemini-2.5-flash'
    assert args['config'].system_instruction == p.SYSTEM_PROMPT
    assert args['config'].response_mime_type == 'application/json'
    assert args['contents'] == 'Pin 2%. Trạm 8km.'


def test_missing_key_is_explicit(monkeypatch):
    for name in ('GEMINI_API_KEY', 'GOOGLE_API_KEY'):
        monkeypatch.delenv(name, raising=False)
    with pytest.raises(RuntimeError):
        p.evaluate_prompt('Pin 2%')
    assert p.main([]) == 2


def test_api_error_is_not_converted_to_success(monkeypatch, tmp_path):
    monkeypatch.setenv('GEMINI_API_KEY', 'unit-test-not-a-real-key')
    monkeypatch.setattr(p, 'evaluate_prompt', MagicMock(side_effect=TimeoutError('secret request details')))
    report = tmp_path / 'report.json'
    assert p.main(['--report', str(report)]) == 1
    text = report.read_text(encoding='utf-8')
    assert 'secret request details' not in text
    assert all(r['status'] == 'failed' for r in json.loads(text)['results'])


def test_offline_evidence_is_labeled(tmp_path):
    report = tmp_path / 'report.json'
    assert p.main(['--offline', '--report', str(report)]) == 0
    data = json.loads(report.read_text(encoding='utf-8'))
    assert data['is_live_evidence'] is False
    assert len(data['results']) == 11
