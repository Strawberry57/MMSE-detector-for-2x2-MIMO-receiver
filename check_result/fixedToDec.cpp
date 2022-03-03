#include <bits/stdc++.h>
#include <fstream>

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

main()
{
   fstream i, o;
   i.open("output.txt", ios::in);
   o.open("output_convert.txt", ios::out);
   while (!i.eof())
   {
      string s;
      getline(i, s);
      o << convert(s) << endl;
   }
   i.close();
   o.close();

   // =============== TEST ==================
   string a = "1111110110101100";
   string b = "1111110011011111";
   string result = "1111001100000000";
   float a_dec = convert(a);
   float b_dec = convert(b);
   cout << a_dec + b_dec << endl;
   float result_dec = convert(result);
   cout << "a = " << a_dec << endl;
   cout << "b = " << b_dec << endl;
   cout << "result = " << result_dec << endl;
   // 1111111100000000 ---- (-1)
   // 1111111000000000 ---- (-2)
   // 1111110100000000 ---- (-3)
   // 1111101100000000 ---- (-5)
}
