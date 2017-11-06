def check_palindrome():
    string = str(input("Please enter a string: "))

    for i in range(len(string)):
        if not string[i] == string[len(string) - 1 - i]:
            return False

    return True

if __name__ == "__main__":
    ret = check_palindrome()
    if ret:
        print("Palindrome")
    else:
        print("No Palindrome")

    raise SystemExit
