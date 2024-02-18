import os
import subprocess
import platform


def get_cpu_info():
    cpu_info = {}
    try:
        output = subprocess.check_output(['wmic', 'cpu', 'get', 'name'])
        cpu_info['Name'] = output.decode('utf-8').strip().split('\n')[1]
    except subprocess.CalledProcessError:
        cpu_info['Name'] = 'N/A'
    return cpu_info


def get_ram_info():
    ram_info = {}
    try:
        output = subprocess.check_output(
            ['wmic', 'memorychip', 'get', 'Capacity'])
        total_memory_bytes = sum(int(x) for x in output.decode(
            'utf-8').strip().split('\n')[1:] if x.strip())
        ram_info['Total'] = f"{total_memory_bytes / (1024 ** 3):.2f} GB"
    except subprocess.CalledProcessError:
        ram_info['Total'] = 'N/A'
    return ram_info


def get_gpu_info():
    gpu_info = []
    try:
        output = subprocess.check_output(
            ['wmic', 'path', 'win32_videocontroller', 'get', 'caption'])
        gpu_names = output.decode('utf-8').strip().split('\n')[1:]
        for gpu_name in gpu_names:
            gpu_info.append({'Name': gpu_name.strip()})
    except subprocess.CalledProcessError:
        gpu_info.append({'Name': 'N/A'})
    return gpu_info


def get_disk_info():
    disk_info = []
    try:
        output = subprocess.check_output(['wmic', 'diskdrive', 'get', 'size'])
        sizes = [int(x) for x in output.decode(
            'utf-8').strip().split('\n')[1:] if x.strip()]
        for size in sizes:
            disk_info.append({'Total': f"{size / (1024 ** 3):.2f} GB"})
    except subprocess.CalledProcessError:
        disk_info.append({'Total': 'N/A'})
    return disk_info


def get_os_info():
    os_info = {
        "OS Name": platform.system(),
        "OS Version": platform.version(),
        "OS Release": platform.release(),
        "Architecture": platform.architecture()[0]
    }
    return os_info


def get_display_info():
    display_info = []
    try:
        output = subprocess.check_output(
            ['wmic', 'desktopmonitor', 'get', 'screenheight,screenwidth'])
        resolutions = output.decode('utf-8').strip().split('\n')[1:]
        for resolution in resolutions:
            parts = resolution.strip().split()
            if len(parts) >= 2:
                width, height = parts
                display_info.append({'Resolution': f"{width}x{height}"})
            else:
                display_info.append({'Resolution': 'N/A'})
    except subprocess.CalledProcessError:
        display_info.append({'Resolution': 'N/A'})
    return display_info


def get_motherboard_info():
    motherboard_info = {}
    try:
        output = subprocess.check_output(
            ['wmic', 'baseboard', 'get', 'product,manufacturer,serialnumber,version'])
        print(output)
        lines = output.decode('utf-8').strip().split('\n')[1:]
        if lines:
            info = lines[0].strip().split(None, 3)
            if len(info) >= 4:
                product, manufacturer, serialnumber, version = info
                motherboard_info = {
                    'Product': product,
                    'Manufacturer': manufacturer,
                    'Serial Number': serialnumber,
                    'Version': version
                }
    except subprocess.CalledProcessError:
        pass  # Handle the error gracefully
    return motherboard_info


def write_to_file(system_info):
    with open("system_info.txt", "w") as file:
        for category, info in system_info.items():
            file.write(f"{category} Information:\n")
            if isinstance(info, list):
                for i, item in enumerate(info, start=1):
                    file.write(f"\t{category} {i}:\n")
                    for key, value in item.items():
                        file.write(f"\t\t{key}: {value}\n")
            else:
                for key, value in info.items():
                    file.write(f"\t{key}: {value}\n")
            file.write("\n")


if __name__ == "__main__":
    system_info = {
        "OS": get_os_info(),
        "CPU": get_cpu_info(),
        "RAM": get_ram_info(),
        "GPU": get_gpu_info(),
        "Hard Drive": get_disk_info(),
        "Motherboard": get_motherboard_info(),
        "Display": get_display_info()
    }
    write_to_file(system_info)
    print("System information collected and saved to system_info.txt")
