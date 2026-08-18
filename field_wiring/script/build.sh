# files = glob.glob('examples/inner_shield_branch/build/sheet*.gv')


# NOTE: currently assumes this script is run from the root of the
# WireViz repo, and hard-codes where the yml file lives

# TODO:
# - Pass in path of source files
# - Remove hardcoding of field_wiring/ path
# - Order of connectors & sheets based on gv filename sequence
# - Template the titleblock for sheet number
#

BUILD_DIR=$(mktemp -d)


# Run wireviz on the YAML file to produce the monolithic graphviz "gv" file (containing entire field wiring)
PYTHONPATH="$PYTHONPATH:$PWD/src" python -m wireviz.wv_cli -o "$BUILD_DIR" -f g field_wiring/Field_Wiring.yml

# Since we can't print the entire thing on a single sheet, split it up.
# ccomps does magic to split parts into individual gv files.
# Each will be called "sheet_n.gv in the dir specified
ccomps -x -o "$BUILD_DIR/sheet.gv" "$BUILD_DIR/Field_Wiring.gv"

for gv_file in "$BUILD_DIR/"*.gv
do

    # For each xyz.gv, next command creates xyz.gv.ps alongside, one for each sheet.
    dot -O -Tps -Gpage=17,11 -Gmargin=0.5 -Gsize=12,7.5 -Gcenter=true "$gv_file"
done


# See https://web.mit.edu/ghostscript/src/ghostscript-8.14/doc/Use.htm#Known_paper_sizes

# Create the A3 PDF
gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dDEVICEWIDTHPOINTS=1190 -dDEVICEHEIGHTPOINTS=842 -dFIXEDMEDIA \
   -sOutputFile=field_wiring/field_wiring.pdf "$BUILD_DIR/"*.ps


# Overlay the titleblock on the created PDF.
qpdf field_wiring/field_wiring.pdf --overlay field_wiring/Titleblock.pdf --repeat=1 -- field_wiring/field_wiring_with_titleblock.pdf


# echo "$BUILD_DIR"
rm -rf "$BUILD_DIR"
