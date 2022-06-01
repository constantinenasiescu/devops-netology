# devops-netology

## Домашнее задание к занятию "7.5. Основы golang"

1) Выполнено. Golang установлен.
2) Выполнено.
3) Выполнено.

1. Напишите программу для перевода метров в футы (1 фут = 0.3048 метр). Можно запросить исходные данные у пользователя, а можно статически задать в коде. Для взаимодействия с пользователем можно использовать функцию Scanf:

```
package main

import "fmt"

func main() {
    fmt.Print("Enter a number: ")
    var input float64
    fmt.Scanf("%f", &input)

    output := input * 3.28084

    fmt.Printf("%.2f meters is %.2f feets\n", input, output)
}
```

2. Напишите программу, которая найдет наименьший элемент в любом заданном списке, например: x := []int{48,96,86,68,57,82,63,70,37,34,83,27,19,97,9,17,}

```
package main

import "fmt"

func main() {
    array := []int {48,96,86,68,57,82,63,70,37,34,83,27,19,97,9,17,}
    var minValue int = array[0]

    for i := 1; i < len(array); i++ {
        if array[i] < minValue {
            minValue = array[i]
        }
    }

    fmt.Printf("The min value is - %d\n", minValue)
}
```

3. Напишите программу, которая выводит числа от 1 до 100, которые делятся на 3. То есть (3, 6, 9, …).

```
package main

import "fmt"

func main() {
    for i := 1; i < 100; i++ {
        if i % 3 == 0 {
            fmt.Printf("%d ", i)
        }
    }

    fmt.Println()
}
```