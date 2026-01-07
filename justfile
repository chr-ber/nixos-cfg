default: switch

reload:
    nh os switch . --offline

switch:
    nh os switch .

switch-dry:
    nh os switch --dry .    

build:
    nh os build .

update:
    nh os test . --update --diff always
