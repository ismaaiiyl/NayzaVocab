import json
import os

def sync_arb(source_file, target_file):
    with open(source_file, 'r', encoding='utf-8') as f:
        source_data = json.load(f)
    
    if os.path.exists(target_file):
        with open(target_file, 'r', encoding='utf-8') as f:
            target_data = json.load(f)
    else:
        target_data = {}

    # Merge keys: keep target value if exists, else use source value
    new_data = {}
    for key in source_data:
        if key in target_data:
            new_data[key] = target_data[key]
        else:
            new_data[key] = source_data[key]
    
    # Save with specific formatting to ensure line count matches if possible
    # (Though line count depends on content, but we want all keys to be present)
    with open(target_file, 'w', encoding='utf-8') as f:
        json.dump(new_data, f, ensure_ascii=False, indent=2)

script_dir = os.path.dirname(os.path.abspath(__file__))
source = os.path.join(script_dir, 'app_en.arb')
targets = [
    os.path.join(script_dir, 'app_uz.arb'),
    os.path.join(script_dir, 'app_ru.arb'),
    os.path.join(script_dir, 'app_ar.arb'),
    os.path.join(script_dir, 'app_de.arb'),
    os.path.join(script_dir, 'app_ko.arb'),
]

for t in targets:
    sync_arb(source, t)
    print(f'Synced {t}')
