#!/bin/bash -e

echo "=== Current directory ==="
pwd && ls || echo "--- Directory listing failed ---"

echo ""
if [ -d sources ]; then
    echo "=== Sources folder contents (yml only) ===" 
    find .sources/ type f \( -name "*.md\)" 2>/dev/null | head -20
    
elif compgen -G "./sour*" > /dev/null; then  
   for d in ./so* ; do
        if [ "$d" != "source_tree.md" ]; then 
            echo "--- Directory: $d ---"
            ls --format=none "$(dirname $(realpath "${BASH_SOURCE[0]}"))/sources/" | grep -E '\.(md|yml)$'
       fi; done

else   
    find . 2>/dev/null \( ! -name "*.git" \) exec sh << 'EOFX' +  
        ls --format=none "$1"
   EOFX {} +
fi