#include <bits/stdc++.h>
using namespace std;

#define N 16
#define Q 8
#define PI 3.141592653589793
float convert(string a)
{
    int size = a.size();
    int bits_size = N;
    int fraction_size = Q;
    float result = 0;
    char sign_bit = a[0];
    if (size != bits_size)
    {
        cout << "ERROR: Invalid input";
        return (float)0;
    }
    string interger = a.substr(1, bits_size - fraction_size - 1);
    string fraction = a.substr(bits_size - fraction_size);
    for (int i = 0; i < interger.size(); i++)
        if (interger[i] == '1')
            result += pow(2, interger.size() - i - 1);

    for (int i = -1; i >= 0 - fraction.size(); i--)
    {
        if (fraction[-i - 1] == '1')
            result += pow(2, i);
    }
    if (a[0] == '0')
        return result;
    else if (a[0] == '1')
        return result - pow(2, (bits_size - fraction_size - 1));
    else
    {

        cout << "ERROR: Invalid input" << endl;
        return (float)0;
    }
}

float decode(string a)
{
    int size = a.size();
    int bits_size = N;
    int fraction_size = Q;
    float result = 0;
    char sign_bit = a[0];
    if (size != bits_size)
    {
        cout << "ERROR: Invalid input";
        return (float)0;
    }
    string interger = a.substr(1, bits_size - fraction_size - 1);
    string fraction = a.substr(bits_size - fraction_size);
    for (int i = 0; i < interger.size(); i++)
        if (interger[i] == '1')
            result += pow(2, interger.size() - i - 1);

    for (int i = -1; i >= 0 - fraction.size(); i--)
    {
        if (fraction[-i - 1] == '1')
            result += pow(2, i);
    }
    if (a[0] == '0')
        return result;
    else if (a[0] == '1')
        return result - pow(2, (bits_size - fraction_size - 1));
    else
    {

        cout << "ERROR: Invalid input" << endl;
        return (float)0;
    }
}

string ***getInput(string filePath)
{
    string ***input = new string **[3];
    string **h_matrix = 0;
    string **n_matrix = 0;
    string **y_matrix = 0;
    h_matrix = new string *[4];
    n_matrix = new string *[4];
    y_matrix = new string *[4];

    ifstream file(filePath.c_str());

    for (int i = 0; i < 4; i++)
    {
        h_matrix[i] = new string[4];
        for (int j = 0; j < 4; j++)
        {
            getline(file, h_matrix[i][j]);
            // cout << decode(h_matrix[i][j]) << " ";
        }
        // cout << endl;
    }
    // cout << " y matrix" << endl;
    for (int i = 0; i < 4; i++)
    {
        y_matrix[i] = new string[2];
        for (int j = 0; j < 2; j++)
        {
            getline(file, y_matrix[i][j]);
            // cout << decode(y_matrix[i][j]) << " ";
        }
        // cout << endl;
    }
    // cout << " n matrix" << endl;
    for (int i = 0; i < 4; i++)
    {
        n_matrix[i] = new string[2];
        for (int j = 0; j < 2; j++)
        {
            getline(file, n_matrix[i][j]);
            // cout << decode(n_matrix[i][j]) << " ";
        }
        // cout << endl;
    }
    file.close();
    input[0] = h_matrix;
    input[1] = y_matrix;
    input[2] = n_matrix;
    return input;
}

float **decodeMatrix(string **m, int row)
{
    float **matrix = 0;
    matrix = new float *[4];
    for (int i = 0; i < 4; i++)
    {
        matrix[i] = new float[row];
        for (int j = 0; j < row; j++)
            matrix[i][j] = decode(m[i][j]);
    }
    return matrix;
}

void subadd(float a[4][4], float b[4][4], float subadd[4][4])
{
    for (int i = 0; i < 4; i++)
        for (int j = 0; j < 2; j++)
            subadd[i][j] = a[i][j] - b[i][j];
}
void multiple(float a[4][4], float **b, float mul[4][4]) // a 4x4 //b 4x2
{
    for (int i = 0; i < 4; i++)
    {
        for (int j = 0; j < 2; j++)
        {
            mul[0][0] = a[0][0] * b[0][0] + a[0][1] * b[1][0] + a[0][2] * b[2][0] + a[0][3] * b[3][0];
            mul[1][0] = a[1][0] * b[0][0] + a[1][1] * b[1][0] + a[1][2] * b[2][0] + a[1][3] * b[3][0];
            mul[2][0] = a[2][0] * b[0][0] + a[2][1] * b[1][0] + a[2][2] * b[2][0] + a[2][3] * b[3][0];
            mul[3][0] = a[3][0] * b[0][0] + a[3][1] * b[1][0] + a[3][2] * b[2][0] + a[3][3] * b[3][0];
            mul[0][1] = a[0][0] * b[0][1] + a[0][1] * b[1][1] + a[0][2] * b[2][1] + a[0][3] * b[3][1];
            mul[1][1] = a[1][0] * b[0][1] + a[1][1] * b[1][1] + a[1][2] * b[2][1] + a[1][3] * b[3][1];
            mul[2][1] = a[2][0] * b[0][1] + a[2][1] * b[1][1] + a[2][2] * b[2][1] + a[2][3] * b[3][1];
            mul[3][1] = a[3][0] * b[0][1] + a[3][1] * b[1][1] + a[3][2] * b[2][1] + a[3][3] * b[3][1];
        }
    }
    // for (int i = 0; i < 4; i++)
    // {
    //     for (int j = 0; j < 2; j++)
    //     {
    //         cout << mul[i][j] << " ";
    //     }
    //     cout << endl;
    // }
}
void QR(float **a, float q[4][4], float r[4][4])
{
    float R_11, R_12, R_13, R_14, R_23, R_22, R_24, R_33, R_34, R_44;
    float matrix1[4][4];
    float matrix2[4][4];
    float matrix3[4][4];
    float matrix4[4][4];
    float matrix5[4][4];
    float matrix6[4][4];
    float matrix7[4][4];
    r[1][0] = r[2][0] = r[2][1] = r[3][0] = r[3][1] = r[3][2] = 0;
    float sum1 = 0;
    float sum2 = 0;
    float sum3 = 0;
    float sum4 = 0;

    for (int i = 0; i < 4; i++)
    {
        matrix1[i][0] = a[i][0];
    }
    for (int i = 0; i < 4; i++)
    {
        matrix1[i][0] *= matrix1[i][0];
        sum1 += matrix1[i][0];
    }
    // cout << "------*-----" << endl;
    // for (int i = 0; i < 4; i++)
    // {
    //     cout << matrix1[i][0] << endl;
    // }
    // cout << " -----" << endl;
    R_11 = r[0][0] = sqrt(sum1);
    // cout << R_11 << endl;
    for (int i = 0; i < 4; i++)
    {
        a[i][0] *= 1 / sqrt(sum1);
        q[i][0] = a[i][0];
        // cout << q[i][0] << " " << endl;
    }
    R_12 = r[0][1] = q[0][0] * a[0][1] + q[1][0] * a[1][1] + q[2][0] * a[2][1] + q[3][0] * a[3][1];
    // cout << R_12 << endl;
    for (int i = 0; i < 4; i++)
    {
        matrix2[0][1] = a[0][1] - R_12 * q[0][0];
        matrix2[1][1] = a[1][1] - R_12 * q[1][0];
        matrix2[2][1] = a[2][1] - R_12 * q[2][0];
        matrix2[3][1] = a[3][1] - R_12 * q[3][0];
    }
    for (int i = 0; i < 4; i++)
    {
        matrix3[i][1] = matrix2[i][1];
    }
    // cout << "--" << endl;
    for (int i = 0; i < 4; i++)
    {
        matrix2[i][1] *= matrix2[i][1];
        sum2 += matrix2[i][1];
    }
    R_22 = r[1][1] = sqrt(sum2);
    // cout << R_22 << endl;
    for (int i = 0; i < 4; i++)
    {
        matrix3[i][1] *= 1 / sqrt(sum2);
        q[i][1] = matrix3[i][1];
        // cout << q[i][1] << " " << endl;
    }
    R_13 = r[0][2] = q[0][0] * a[0][2] + q[1][0] * a[1][2] + q[2][0] * a[2][2] + q[3][0] * a[3][2];
    R_23 = r[1][2] = q[0][1] * a[0][2] + q[1][1] * a[1][2] + q[2][1] * a[2][2] + q[3][1] * a[3][2];
    // cout << R_23 << endl;
    matrix4[0][2] = a[0][2] - R_13 * q[0][0] - R_23 * q[0][1];
    matrix4[1][2] = a[1][2] - R_13 * q[1][0] - R_23 * q[1][1];
    matrix4[2][2] = a[2][2] - R_13 * q[2][0] - R_23 * q[2][1];
    matrix4[3][2] = a[3][2] - R_13 * q[3][0] - R_23 * q[3][1];
    for (int i = 0; i < 4; i++)
    {
        matrix5[i][2] = matrix4[i][2];
        // cout << matrix5[i][2] << endl;
    }
    for (int i = 0; i < 4; i++)
    {
        matrix4[i][2] *= matrix4[i][2];
        sum3 += matrix4[i][2];
    }
    R_33 = r[2][2] = sqrt(sum3);
    // cout << R_33 << endl;
    for (int i = 0; i < 4; i++)
    {
        matrix5[i][2] *= 1 / sqrt(sum3);
        q[i][2] = matrix5[i][2];
        // cout << q[i][2] << " " << endl;
    }
    R_14 = r[0][3] = q[0][0] * a[0][3] + q[1][0] * a[1][3] + q[2][0] * a[2][3] + q[3][0] * a[3][3];
    R_24 = r[1][3] = q[0][1] * a[0][3] + q[1][1] * a[1][3] + q[2][1] * a[2][3] + q[3][1] * a[3][3];
    R_34 = r[2][3] = q[0][2] * a[0][3] + q[1][2] * a[1][3] + q[2][2] * a[2][3] + q[3][2] * a[3][3];
    matrix6[0][3] = a[0][3] - R_14 * q[0][0] - R_24 * q[0][1] - R_34 * q[0][2];
    matrix6[1][3] = a[1][3] - R_14 * q[1][0] - R_24 * q[1][1] - R_34 * q[1][2];
    matrix6[2][3] = a[2][3] - R_14 * q[2][0] - R_24 * q[2][1] - R_34 * q[2][2];
    matrix6[3][3] = a[3][3] - R_14 * q[3][0] - R_24 * q[3][1] - R_34 * q[3][2];
    for (int i = 0; i < 4; i++)
    {
        matrix7[i][3] = matrix6[i][3];
    }
    for (int i = 0; i < 4; i++)
    {
        matrix6[i][3] *= matrix6[i][3];
        sum4 += matrix6[i][3];
    }
    r[3][3] = sqrt(sum4);
    for (int i = 0; i < 4; i++)
    {
        matrix7[i][3] *= 1 / sqrt(sum4);
        q[i][3] = matrix7[i][3];
        // cout << q[i][3] << " " << endl;
    }
}
void transpose(float matrix[4][4], float matrixT[4][4])
{
    for (int i = 0; i < 4; ++i)
        for (int j = 0; j < 4; ++j)
        {
            matrixT[j][i] = matrix[i][j];
        }
}
void equation(float X[4][4], float R[4][4], float S[4][4])
{
    float x, y, z, t;
    t = S[3][0] / R[3][3];
    z = (S[2][0] - t * R[2][3]) / R[2][2];
    y = (S[1][0] - (t * R[1][3] + z * R[1][2])) / R[1][1];
    x = (S[0][0] - (t * R[0][3] + z * R[0][2] + y * R[0][1])) / R[0][0];
    X[0][0] = x;
    X[1][0] = y;
    X[2][0] = z;
    X[3][0] = t;
    float a, b, c, d;
    d = S[3][1] / R[3][3];
    c = (S[2][1] - d * R[2][3]) / R[2][2];
    b = (S[1][1] - (d * R[1][3] + c * R[1][2])) / R[1][1];
    a = (S[0][1] - (d * R[0][3] + c * R[0][2] + b * R[0][1])) / R[0][0];
    X[0][1] = a;
    X[1][1] = b;
    X[2][1] = c;
    X[3][1] = d;
    cout << x << " " << a << endl;
    cout << y << " " << b << endl;
    cout << z << " " << c << endl;
    cout << t << " " << d << endl;
}
main()
{
    string ***input = getInput("input.txt");
    float **h_matrix = decodeMatrix(input[0], 4);
    float **y_matrix = decodeMatrix(input[1], 2);
    float **n_matrix = decodeMatrix(input[2], 2);
    float q_matrix_T[4][4];
    float q_matrix[4][4];
    float r_matrix[4][4];
    float QY_matrix[4][4];
    float QN_matrix[4][4];
    float YN_matrix[4][4];
    float X_matrix[4][4];

    // subadd(y_matrix, n_matrix);
    // cout << endl;
    // cout << h_matrix[2][0] << endl;
    for (int i = 0; i < 4; i++)
    {
        for (int j = 0; j < 4; j++)
        {
            cout << h_matrix[i][j] << " ";
        }
        cout << endl;
    }
    // cout << h_matrix[1][1];
    cout << "-----------" << endl;
    // multiple(h_matrix, y_matrix);
    QR(h_matrix, q_matrix, r_matrix);
    transpose(q_matrix, q_matrix_T);
    multiple(q_matrix_T, y_matrix, QY_matrix);
    multiple(q_matrix_T, n_matrix, QN_matrix);
    subadd(QY_matrix, QN_matrix, YN_matrix);
    equation(X_matrix, r_matrix, YN_matrix);
    ofstream output("output_c++.txt");
    for (int i = 0; i < 4; i++)
    {
        for (int j = 0; j < 2; j++)
        {
            output << X_matrix[i][j] << endl;
        }
    }
    output.close();
    return 0;
}