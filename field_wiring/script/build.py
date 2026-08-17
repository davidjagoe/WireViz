import re, glob, subprocess


# HOLD: I've just moved this to bash for now. Will only need this
# script when sorting the ps files for pagination.

# hold: this is to sort the sheets based on the commented tweak in graph viz yaml file.

# files = []
# for f in glob.glob('examples/inner_shield_branch/build/sheet*.gv'):
#     v = re.search(r'sortv=(\d+)', open(f, encoding='latin-1').read())
#     files.append((int(v.group(1)) if v else 999, f))

# files.sort()

files = glob.glob('examples/inner_shield_branch/build/sheet*.gv')

for n, f in enumerate(files, 1):
    subprocess.run(['dot', '-Tps', '-Gpage=17,11', '-Gmargin=0.5', '-Gsize=16,10', '-Gcenter=true', '-o', f'examples/inner_shield_branch/build/sheet{n:02d}.ps', f], check=True)
