import os
from pathlib import Path

PATH_ROOT = Path(__file__).absolute().parent
PATH_JSON = PATH_ROOT / 'models'
PATH_YAML = PATH_ROOT / 'models-yaml'

if not PATH_YAML.exists():
    PATH_YAML.mkdir()

for p_json in PATH_JSON.glob('*.json'):
    p_yaml = PATH_YAML / p_json.name.replace('.json', '.yml')
    os.system(f'json2yaml {str(p_json)} > {str(p_yaml)}')
    print('Done:', p_yaml)
