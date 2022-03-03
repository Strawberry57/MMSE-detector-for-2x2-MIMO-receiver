#include <iostream>
#include <math.h>
#include <fstream>

using namespace std;

int main()
{
    fstream f1, f2, o;
    double input1, input2;
    double sum = 0, tb = 0;
    int n = 0;

    f1.open("output.txt", ios::in);
    f2.open("output_convert.txt", ios::in);
    o.open("compare.txt", ios::out);
    while (!f1.eof() || !f2.eof())
    {
        n++;
        f1 >> input1;
        f2 >> input2;
        tb = abs(input1 - input2) / abs(input1);
        o << "Measurement error point [" << n << "] = " << tb * 100 << " %" << endl;
        sum += tb;
    }
    o << "Average error = " << (sum / n) * 100 << " %";
    f1.close();
    f2.close();
    o.close();
    return 0;
}