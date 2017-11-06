def array_m_product(array, m):
    """look for the maximum product in an array of integers"""

    n = len(array)
    max = 0

    if not (n < m or m == 0):
        for elem in range(0, n - m + 1):
            prod = array[elem]
            for x in range(1, m):
                prod *= array[elem + x]

            if prod > max:
                max = prod

    return max


if __name__ == "__main__":
    array = [1, 3, 7, 4, 2, 1, 9, 2, 3, 4]
    print(array_m_product(array, 3))
