# files = glob.glob('examples/inner_shield_branch/build/sheet*.gv')


# NOTE: currently assumes this script is run from the root of the
# WireViz repo, and hard-codes where the yml file lives
#

BUILD_DIR=$(mktemp -d)

# mkdir "$BUILD_DIR/gv_sheets"

# pushd ../../

# Run wireviz on the YAML file to produce the monolithic graphviz "gv" file (containing entire field wiring)
PYTHONPATH="$PYTHONPATH:$PWD/src" python -m wireviz.wv_cli -o "$BUILD_DIR" -f g field_wiring/Field_Wiring.yml

# Since we can't print the entire thing on a single sheet, split it up.
# ccomps does magic to split parts into individual gv files.
# Each will be called "sheet_n.gv in the dir specified
ccomps -x -o "$BUILD_DIR/sheet.gv" "$BUILD_DIR/Field_Wiring.gv"

for gv_file in "$BUILD_DIR/"*.gv
do

    # For each xyz.gv file will create xyz.gv.ps alongside, one for each sheet as specified
    dot -O -Tps -Gpage=16.5433,11.6933 -Gmargin=0.5 -Gsize=16,10 -Gcenter=true "$gv_file"

    # For 11x17 print
    # dot -O -Tps -Gpage=17,11 -Gmargin=0.5 -Gsize=16,10 -Gcenter=true "$gv_file"
done


gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dDEVICEWIDTHPOINTS=1224 -dDEVICEHEIGHTPOINTS=792 -dFIXEDMEDIA \
   -sOutputFile=field_wiring/field_wiring.pdf "$BUILD_DIR/"*.ps


echo "$BUILD_DIR"
rm -rf "$BUILD_DIR"

# popd
