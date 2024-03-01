import subprocess
import platform
import sys
import re


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
            ['powershell',
                'Get-CimInstance -ClassName Win32_VideoController | ForEach-Object { $_.VideoModeDescription }'],
            shell=True,
            universal_newlines=True
        )
        # Split the output into lines
        lines = output.strip().split('\n')

        for line in lines:
            line = line.strip()
            display_info.append({'Resolution': line})
    except subprocess.CalledProcessError:
        display_info.append({'Resolution': 'N/A'})
    return display_info


def get_motherboard_info():
    motherboard_info = {}
    try:
        output = subprocess.check_output(
            ['wmic', 'baseboard', 'get', 'product,manufacturer,serialnumber,version'])
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


def get_network_card_info():
    network_cards = []
    try:
        output = subprocess.check_output(
            ['ipconfig', '/all'], universal_newlines=True)
        # Split the output into sections for each network adapter
        sections = re.split(r'\r?\n\r?\n', output.strip())
        for section in sections:
            adapter_info = {}
            lines = section.strip().split('\n')
            for line in lines:
                if line.strip().startswith('Ethernet adapter') or line.strip().startswith('Wireless LAN adapter'):
                    adapter_info['Name'] = line.strip().split(':')[1].strip()
                elif 'Physical Address' in line:
                    adapter_info['MAC Address'] = line.split(':')[1].strip()
                elif 'Description' in line:
                    adapter_info['Description'] = line.split(':')[1].strip()
                elif 'IPv4 Address' in line:
                    ipv4_address = line.split(':')[1].strip()
                    if ipv4_address != '':
                        adapter_info['IPv4 Address'] = ipv4_address
                    else:
                        break
                elif 'Subnet Mask' in line:
                    adapter_info['Subnet Mask'] = line.split(':')[1].strip()
                elif 'Default Gateway' in line:
                    adapter_info['Default Gateway'] = line.split(':')[
                        1].strip()
            if 'IPv4 Address' in adapter_info:
                network_cards.append(adapter_info)
    except subprocess.CalledProcessError:
        pass  # Handle the error gracefully
    return network_cards


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


def runShellCommand(command_list, command_name):
    print(f"Running {command_name}:")
    try:
        process = subprocess.Popen(command_list, stdout=subprocess.PIPE,
                                   stderr=subprocess.STDOUT, bufsize=1, universal_newlines=True)
        for line in iter(process.stdout.readline, ''):
            sys.stdout.write(line)
            sys.stdout.flush()
        process.wait()
        print(f"{command_name} completed successfully.\n\n")
    except subprocess.CalledProcessError as e:
        print(f"{command_name} failed with error: {e}\n\n")


def get_antivirus_list():
    running_antivirus_list = []
    try:
        if platform.system() == 'Windows':
            # Use WMIC to query for running antivirus products
            output = subprocess.check_output(
                ['wmic', '/Namespace:\\\\root\\SecurityCenter2', 'Path',
                    'AntiVirusProduct', 'Get', 'displayName', '/Format:List'],
                universal_newlines=True
            )

            # Extract antivirus product names from the output
            for line in output.split('\n'):
                if line.strip().startswith('displayName='):
                    antivirus_name = line.strip().split('=')[1]
                    running_antivirus_list.append(
                        {'Name': antivirus_name.strip()})

    except subprocess.CalledProcessError as e:
        # Handle any errors gracefully
        print(f'Error retrieving antivirus information: {e}')

    return running_antivirus_list


if __name__ == "__main__":
    system_info = {
        "OS": get_os_info(),
        "CPU": get_cpu_info(),
        "RAM": get_ram_info(),
        "GPU": get_gpu_info(),
        "Hard Drive": get_disk_info(),
        "Motherboard": get_motherboard_info(),
        "Display": get_display_info(),
        "Network Card": get_network_card_info(),
        "Anti-virus":
            get_antivirus_list()
    }
    write_to_file(system_info)
    print("System information collected and saved to system_info.txt\n")

    print("Starting windows recovery commands")

    runShellCommand(['sfc', '/scannow'], "Sfc scan")
    runShellCommand(['DISM', '/Online', '/Cleanup-Image',
                    '/CheckHealth'], "DISM CheckHealth")
    runShellCommand(['DISM', '/Online', '/Cleanup-Image',
                    '/ScanHealth'], "DISM ScanHealth")
