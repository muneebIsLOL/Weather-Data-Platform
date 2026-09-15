from unittest.mock import Mock, patch
from src.ELT.extract.data import extract_data
import httpx, pytest


@patch("src.ELT.extract.data.httpx.get")
def test_extract_http_request(mock_get):

    mock_get.side_effect = httpx.HTTPError("Network Error")

    with pytest.raises(httpx.HTTPError):
        extract_data()


@patch("src.ELT.extract.data.httpx.get")
def test_extract_empty_data(mock_get):
    mock_response = Mock()

    mock_response.json.side_effect = ValueError("Invalid JSON!")

    mock_get.return_value = mock_response

    with pytest.raises(ValueError):
        extract_data()
