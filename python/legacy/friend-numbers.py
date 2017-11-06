def real_dividers(n, p = 1):
    divs = list()

    while p < n:
        if n % p == 0:
            divs.append(p)
        p += 1

    return divs

def divisor_sum(divs):
    return sum(divs)


def friends():
    while n < 10000:
        pass

print(real_dividers(220))
print(divisor_sum(real_dividers(284)))
