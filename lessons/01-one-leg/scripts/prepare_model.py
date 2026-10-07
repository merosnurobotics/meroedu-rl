"""Fill checkout-local paths in XML templates; preserve every physical field."""
from pathlib import Path
root = Path(__file__).resolve().parents[1]
for template in (root / 'assets').rglob('*.xml.in'):
    output = template.with_suffix('')
    output.write_text(template.read_text().replace('@LESSON_ROOT@', str(root)))
    print(output.relative_to(root))
