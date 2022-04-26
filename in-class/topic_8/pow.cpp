#include <iostream>

unsigned long long power(unsigned int, unsigned short);

int main(int argc, char const *argv[])
{
    std::cout << power(3, 23) << std::endl;
    return 0;
}

unsigned long long power(unsigned int base, unsigned short exp)
{
    int i{sizeof exp * 8};
    unsigned long long prod{1};

    // state 1
    while ((exp & 0x8000) == 0)
    {
        exp <<= 1;
        --i;
    }
    
    // state 2
    for ( ; i > 0; --i, exp <<= 1)
    {
        prod *= prod;
        if ((exp & 0x8000) > 0)
            prod *= base;
    }
    
    return prod;
}
