import os
import sys
import datetime


def search(query, log_file):
    # Output date and provided parameter
    with open(log_file, 'a', encoding='utf-8') as f:
        f.write(f"Call DateTime: {datetime.datetime.now()}\n")
        f.write(f"Search parameter: {query}\n\n")

    for root, dirs, files in os.walk("C:\\", topdown=True):

        for name in files:
            if query in name:
                file_path = os.path.abspath(os.path.join(root, name))
                with open(log_file, 'a', encoding='utf-8') as f:
                    f.write(f"File found: {name}\n")
                    f.write(f"File path: {file_path}\n")
                    f.write(
                        f"Creation time: {datetime.datetime.fromtimestamp(os.stat(file_path).st_ctime)}\n")
                    f.write(
                        f"Access time: {datetime.datetime.fromtimestamp(os.stat(file_path).st_atime)}\n")
                    f.write("--------\n")

        for name in dirs:
            if query in name:
                dir_path = os.path.abspath(os.path.join(root, name))
                with open(log_file, 'a', encoding='utf-8') as f:
                    f.write(f"Directory found: {name}\n")
                    f.write(f"Directory path: {dir_path}\n")
                    f.write(
                        f"Creation time: {datetime.datetime.fromtimestamp(os.stat(dir_path).st_ctime)}\n")
                    f.write(
                        f"Access time: {datetime.datetime.fromtimestamp(os.stat(dir_path).st_atime)}\n")
                    f.write(
                        f"Directory contents: {os.listdir(dir_path)}\n")
                    f.write("--------\n")
    with open(log_file, 'a', encoding='utf-8') as f:
        f.write("END OF SEARCH\n")
        f.write("##############################################\n\n")


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Please type: python main.py <search_term>")
        sys.exit(1)

    search_query = sys.argv[1]
    LOG_FILE = "search_log.log"

    search(search_query, LOG_FILE)
