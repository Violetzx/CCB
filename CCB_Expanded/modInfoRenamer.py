import os

def get_areas():
    return [
        'Africa',
        'Asia',
        'Europe',
        'Mediterranean',
        'Meso',
        'MiddleEast',
        'NorthAmerica',
        'SouthAmerica',
        'SouthEastAsia'
    ]
    
def get_mods_in_area(area):
    return [
        name for name in os.listdir(f'{area}')
        if os.path.isdir(f'{area}/{name}')
    ]

def rename_modinfo_files():
    for area in get_areas():
        for mod in get_mods_in_area(area):
            # print(f'{area}/{mod}')
            mod_dir = os.path.join(area, mod)
            for file in os.listdir(mod_dir):
                if file.endswith('.modinfo'):
                    modinfo_path = os.path.join(mod_dir, file)
                    new_modinfo_path = os.path.join(mod_dir, "files.xml")
                    os.rename(modinfo_path, new_modinfo_path)
                    print(f'Renamed {modinfo_path} to {new_modinfo_path}')

if __name__ == "__main__":
    rename_modinfo_files()