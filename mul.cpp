#include <iostream>

int a{13};
int b{25};

int main(int argc, char const *argv[])
{
    int sum{0};
    while(b > 0)
    {
        if (b & 1)
            sum += a;
        a <<= 1;
        b >>= 1;
    }

    std::cout << sum << std::endl;
    
    return 0;
}
