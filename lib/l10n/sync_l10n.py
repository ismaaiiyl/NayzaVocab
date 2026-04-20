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

source = 'c:/Users/tolib/StudioProjects/NayzaVocab/lib/l10n/app_en.arb'
targets = [
    'c:/Users/tolib/StudioProjects/NayzaVocab/lib/l10n/app_uz.arb',
    'c:/Users/tolib/StudioProjects/NayzaVocab/lib/l10n/app_ru.arb',
    'c:/Users/tolib/StudioProjects/NayzaVocab/lib/l10n/app_ar.arb',
    'c:/Users/tolib/StudioProjects/NayzaVocab/lib/l10n/app_de.arb',
    'c:/Users/tolib/StudioProjects/NayzaVocab/lib/l10n/app_ko.arb'
]

for t in targets:
    sync_arb(source, t)
    print(f'Synced {t}')
