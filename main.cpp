#include <iostream>
#include <fstream>

void concatenateFiles(const std::string& outputFile, const std::string& file1, const std::string& file2) {
    std::ifstream input1(file1, std::ios::binary);
    std::ifstream input2(file2, std::ios::binary);
    std::ofstream output(outputFile, std::ios::binary);

    output << input1.rdbuf();
    output << input2.rdbuf();

    std::cout << "Arquivos concatenados com sucesso em " << outputFile << std::endl;
}

int main(int argc, char* argv[]) {
    if (argc < 4) {
        std::cerr << "Uso: " << argv[0] << " <first_file> <second_file> <output_file>" << std::endl;
        return 1;
    }

    std::string loaderFile = argv[1];
    std::string subprocessFile = argv[2];
    std::string outputFile = argv[3];

    concatenateFiles(outputFile, loaderFile, subprocessFile);

    return 0;
}