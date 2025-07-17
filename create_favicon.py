from PIL import Image
import os

try:
    # Load the logo
    logo = Image.open('logo.png')
    
    # Convert to RGBA if needed
    if logo.mode != 'RGBA':
        logo = logo.convert('RGBA')
    
    # Create favicons in different sizes
    sizes = [(16, 16), (32, 32), (48, 48), (64, 64)]
    
    for size in sizes:
        favicon = Image.new('RGBA', size, (0, 0, 0, 0))
        logo_resized = logo.resize(size, Image.Resampling.LANCZOS)
        favicon.paste(logo_resized, (0, 0))
        favicon.save(f'favicon-{size[0]}x{size[1]}.png')
    
    # Create main favicon.ico
    favicon_32 = Image.open('favicon-32x32.png')
    favicon_32.save('favicon.ico', format='ICO', sizes=[(16,16), (32,32), (48,48)])
    
    # Create Apple touch icon
    apple_icon = Image.new('RGBA', (180, 180), (0, 0, 0, 0))
    logo_apple = logo.resize((180, 180), Image.Resampling.LANCZOS)
    apple_icon.paste(logo_apple, (0, 0))
    apple_icon.save('apple-touch-icon.png')
    
    print('All favicons created successfully!')
    
except Exception as e:
    print(f'Error: {e}')