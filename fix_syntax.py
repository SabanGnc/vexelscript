import re

file_path = r'c:\Users\saban\OneDrive\Masaüstü\roblox script\vexelbest.lua'

with open(file_path, 'r', encoding='utf-8') as f:
    code = f.read()

# Fix MinimizeBtn syntax error
old_snippet = """        Tween(FrostyBlur, {Size = 20}, 0.5)
end)

-- Library Engine"""

new_snippet = """        Tween(FrostyBlur, {Size = 20}, 0.5)
    end
end)

-- Library Engine"""

if old_snippet in code:
    code = code.replace(old_snippet, new_snippet)
    print("Fixed MinimizeBtn syntax error.")
else:
    print("MinimizeBtn syntax error not found. Maybe already fixed or formatted differently.")

# Also add the print statement at the top if not there
if 'print("VexelHUB v3.0 Başlatılıyor...")' not in code:
    code = 'print("VexelHUB v3.0 Başlatılıyor...")\n' + code
    print("Added startup print statement.")

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(code)
