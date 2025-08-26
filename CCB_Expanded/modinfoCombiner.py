from bs4 import BeautifulSoup
import xml.etree.ElementTree as ET
import os
import re

def get_mod_folders():
    """
    Returns a list of all folders in the current directory whose names start with 'Mod'.
    """
    return [
        'Africa/SwahiliAlHasanibn',
        'Asia/TibetTrisongDetsen',
        'CIVITASResources',
        'DistrictIcons',
        'Europe/GaulVercingetorix',
        'Mediterranean/MacedonOlympias',
        'Mediterranean/PhoeniciaAhiram',
        'Meso/MayaTeKinichII',
        'Meso/TheoticuanasTeotihuacan',
        'NorthAmerica/ThuleKiviuq',
    ]

def combine_modinfo_files():
    new_mod_dict = {}
    mod_cnt = 0
    author_dict = {}
    special_thanks_dict = {}
    author_dict['Calcifer'] = 1
    author_dict['Apeul'] = 1
    files_dict = {}
    for mod in get_mod_folders():
        modinfo_path = os.path.join(mod, "files.xml")
        if os.path.exists(modinfo_path):
            with open(modinfo_path, 'r', encoding='utf-8') as file:
                data = file.read()

            Bs_data = BeautifulSoup(data, "xml")

            file_tags = Bs_data.find_all("File")
            # Append the string in each File tag with the mod folder name
            for b in file_tags:
                if b.string in files_dict:
                    print(f'same file name used in {mod} and {files_dict[b.string]}: {b.string}')
                b.string = f'{mod}/{b.string}'

            lua_replace_tags = Bs_data.find_all("LuaReplace")
            for b in lua_replace_tags:
                print(f'LuaReplace tag: {b}')
                b.string = f'{mod}/{b.string}'

            for b in file_tags:
                files_dict[b.string] = mod
            for b in lua_replace_tags:
                files_dict[b.string] = mod

            load_order_tags = Bs_data.find_all("LoadOrder")
            # Append the string in each File tag with the mod folder name
            for b in load_order_tags:
                b.string = f'{9-mod_cnt}{b.string}'
                
            author_tags = Bs_data.find_all("Authors")
            for tag in author_tags:
                delimiters = r'[;,\s]+'
                for author in re.split(delimiters, tag.string):
                    author_dict[author] = 1
                    
            special_thanks_tags = Bs_data.find_all("SpecialThanks")
            for tag in special_thanks_tags:
                delimiters = r'[;,\s]+'
                for author in re.split(delimiters, tag.string):
                    special_thanks_dict[author] = 1

            for b in Bs_data.find('Mod'):
                if b.name == 'Properties' or b.name == 'Dependencies' or b.name == None:
                    continue
                if b.name not in new_mod_dict:
                    new_mod_dict[b.name] = ''
                new_mod_dict[b.name] = new_mod_dict[b.name] + str(b) + '\n'
            # break
        mod_cnt = mod_cnt + 1
    sorted_authors = sorted(author_dict.keys(), key=lambda item: item)
    sorted_special_thanks = sorted(special_thanks_dict.keys(), key=lambda item: item)
    extraDependencies = {}
    extraDependencies["1B28771A-C749-434B-9053-D1380C553DE9"] = "LOC_EXPANSION1_MOD_TITLE"
    extraDependencies["4873eb62-8ccc-4574-b784-dda455e74e68"] = "LOC_EXPANSION2_MOD_TITLE"
    extraDependencies["9DE86512-DE1A-400D-8C0A-AB46EBBF76B9"] = "LOC_GRANCOLOMBIA_MAYA_MOD_TITLE"
    extraDependencies["A1100FC4-70F2-4129-AC27-2A65A685ED08"] = "LOC_BYZANTIUM_GAUL_MOD_TITLE"
    extraDependencies["E2749E9A-8056-45CD-901B-C368C8E83DEB"] = "LOC_MACEDONIA_PERSIA_MOD_TITLE"
    dependenciesStr = ''
    for key, value in extraDependencies.items():
        dependenciesStr += f'    <Mod id="{key}" title="{value}"/>\n'
    newFileStr = f'''<?xml version="1.0" encoding="UTF-8"?>
<!-- Release ModID-->
<!-- <Mod id="2a0aa96a-a31c-4ce2-87ec-09152f6f3e00" version="1000"> -->
<!-- WIP ModID-->
<Mod id="2a0aa96a-a31c-4ce2-87ec-09144f6f3e00" version="1000">
  <Properties>
    <Name>BBG Expanded WIP</Name>
    <Description>Expansion of new civs</Description>
    <Authors>{', '.join(sorted_authors)} (alphabetical order)</Authors>
    <SpecialThanks>{', '.join(sorted_special_thanks)} (alphabetical order)</SpecialThanks>
    <CompatibleVersions>1.2,2.0</CompatibleVersions>
  </Properties>\n'''
    newFileStr += f'<Dependencies>\n{dependenciesStr}</Dependencies>\n'
    for key, value in new_mod_dict.items():
        print(key)
        newFileStr += ''.join(value).replace(f'</{key}>\n<{key}>', '')
        # for v in value:
        #     for item in v:
        #         newFileStr += f'item'
        # newFileStr += f'</{key}>\n'
    newFileStr += '</Mod>'
    with open('BBGExpanded.modinfo', 'w') as file:
        file.write(newFileStr)

if __name__ == "__main__":
    print("Combining modinfo files...")
    combine_modinfo_files()