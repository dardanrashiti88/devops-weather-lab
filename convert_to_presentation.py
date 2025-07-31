#!/usr/bin/env python3
"""
Presentation Converter Script
Converts markdown presentation to various formats
"""

import os
import sys
import subprocess
from pathlib import Path

def check_dependencies():
    """Check if required tools are installed"""
    tools = {
        'pandoc': 'Pandoc (https://pandoc.org/)',
        'revealjs': 'RevealJS (https://revealjs.com/)',
        'wkhtmltopdf': 'wkhtmltopdf (https://wkhtmltopdf.org/)'
    }
    
    missing = []
    for tool, description in tools.items():
        try:
            subprocess.run([tool, '--version'], capture_output=True, check=True)
            print(f"✅ {tool} found")
        except (subprocess.CalledProcessError, FileNotFoundError):
            missing.append(f"❌ {tool}: {description}")
    
    if missing:
        print("\nMissing dependencies:")
        for item in missing:
            print(f"  {item}")
        print("\nInstall missing tools to use all conversion options.")
        return False
    return True

def convert_to_powerpoint(md_file, output_file=None):
    """Convert markdown to PowerPoint using pandoc"""
    if output_file is None:
        output_file = md_file.replace('.md', '.pptx')
    
    cmd = [
        'pandoc',
        md_file,
        '-o', output_file,
        '--slide-level=2',
        '--reference-doc=template.pptx'  # Optional: custom template
    ]
    
    try:
        subprocess.run(cmd, check=True)
        print(f"✅ PowerPoint created: {output_file}")
        return True
    except subprocess.CalledProcessError as e:
        print(f"❌ Error creating PowerPoint: {e}")
        return False

def convert_to_html(md_file, output_file=None):
    """Convert markdown to HTML presentation using revealjs"""
    if output_file is None:
        output_file = md_file.replace('.md', '.html')
    
    cmd = [
        'pandoc',
        md_file,
        '-o', output_file,
        '--slide-level=2',
        '-t', 'revealjs',
        '-s',
        '--css=style.css',  # Optional: custom CSS
        '-V', 'theme=white',
        '-V', 'transition=slide'
    ]
    
    try:
        subprocess.run(cmd, check=True)
        print(f"✅ HTML presentation created: {output_file}")
        return True
    except subprocess.CalledProcessError as e:
        print(f"❌ Error creating HTML: {e}")
        return False

def convert_to_pdf(md_file, output_file=None):
    """Convert markdown to PDF"""
    if output_file is None:
        output_file = md_file.replace('.md', '.pdf')
    
    # First convert to HTML, then to PDF
    html_file = md_file.replace('.md', '_temp.html')
    
    # Convert to HTML
    html_cmd = [
        'pandoc',
        md_file,
        '-o', html_file,
        '--slide-level=2',
        '-t', 'revealjs',
        '-s',
        '-V', 'theme=white',
        '-V', 'transition=slide'
    ]
    
    # Convert HTML to PDF
    pdf_cmd = [
        'wkhtmltopdf',
        '--page-size', 'A4',
        '--orientation', 'Landscape',
        '--margin-top', '0.75in',
        '--margin-right', '0.75in',
        '--margin-bottom', '0.75in',
        '--margin-left', '0.75in',
        html_file,
        output_file
    ]
    
    try:
        subprocess.run(html_cmd, check=True)
        subprocess.run(pdf_cmd, check=True)
        os.remove(html_file)  # Clean up temp file
        print(f"✅ PDF created: {output_file}")
        return True
    except subprocess.CalledProcessError as e:
        print(f"❌ Error creating PDF: {e}")
        if os.path.exists(html_file):
            os.remove(html_file)
        return False

def create_custom_css():
    """Create custom CSS for better presentation styling"""
    css_content = """
/* Custom CSS for presentation */
.reveal .slides section {
    text-align: left;
}

.reveal .slides section h1 {
    color: #2c3e50;
    font-size: 2.5em;
    margin-bottom: 0.5em;
}

.reveal .slides section h2 {
    color: #34495e;
    font-size: 1.8em;
    margin-bottom: 0.3em;
}

.reveal .slides section h3 {
    color: #7f8c8d;
    font-size: 1.3em;
}

.reveal .slides section code {
    background-color: #f8f9fa;
    border: 1px solid #e9ecef;
    border-radius: 3px;
    padding: 2px 4px;
    font-family: 'Courier New', monospace;
}

.reveal .slides section pre {
    background-color: #2c3e50;
    color: #ecf0f1;
    border-radius: 5px;
    padding: 15px;
    font-size: 0.8em;
}

.reveal .slides section ul {
    margin-left: 20px;
}

.reveal .slides section li {
    margin-bottom: 0.5em;
}

.reveal .slides section .emoji {
    font-size: 1.2em;
    margin-right: 0.3em;
}

/* Custom slide backgrounds */
.reveal .slides section.title-slide {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
}

.reveal .slides section.title-slide h1,
.reveal .slides section.title-slide h2,
.reveal .slides section.title-slide h3 {
    color: white;
}
"""
    
    with open('style.css', 'w') as f:
        f.write(css_content)
    print("✅ Custom CSS created: style.css")

def main():
    """Main function"""
    print("🚀 DevOps Presentation Converter")
    print("=" * 40)
    
    # Check dependencies
    print("\nChecking dependencies...")
    deps_ok = check_dependencies()
    
    # Available markdown files
    md_files = [
        'DEVOPS_PRESENTATION.md',
        'DEVOPS_PRESENTATION_SLIDES.md'
    ]
    
    available_files = [f for f in md_files if os.path.exists(f)]
    
    if not available_files:
        print("❌ No markdown presentation files found!")
        print("Available files:", md_files)
        return
    
    print(f"\nAvailable presentation files:")
    for i, file in enumerate(available_files, 1):
        print(f"  {i}. {file}")
    
    # Select file
    try:
        choice = int(input(f"\nSelect file (1-{len(available_files)}): ")) - 1
        if choice < 0 or choice >= len(available_files):
            print("❌ Invalid choice!")
            return
        selected_file = available_files[choice]
    except ValueError:
        print("❌ Invalid input!")
        return
    
    print(f"\nSelected: {selected_file}")
    
    # Create custom CSS
    create_custom_css()
    
    # Conversion options
    print("\nConversion options:")
    print("  1. PowerPoint (.pptx)")
    print("  2. HTML Presentation (.html)")
    print("  3. PDF (.pdf)")
    print("  4. All formats")
    
    try:
        choice = input("\nSelect option (1-4): ")
    except KeyboardInterrupt:
        print("\n\n👋 Goodbye!")
        return
    
    success_count = 0
    
    if choice == '1' or choice == '4':
        if convert_to_powerpoint(selected_file):
            success_count += 1
    
    if choice == '2' or choice == '4':
        if convert_to_html(selected_file):
            success_count += 1
    
    if choice == '3' or choice == '4':
        if convert_to_pdf(selected_file):
            success_count += 1
    
    print(f"\n✅ Successfully created {success_count} file(s)")
    
    if success_count > 0:
        print("\n📁 Generated files:")
        base_name = selected_file.replace('.md', '')
        for ext in ['.pptx', '.html', '.pdf']:
            if os.path.exists(base_name + ext):
                print(f"  - {base_name}{ext}")

if __name__ == "__main__":
    main()