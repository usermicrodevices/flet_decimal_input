# Introduction

FletDecimalInput for Flet.

## Examples

```
import flet as ft

from flet_decimal_input import FletDecimalInput


def main(page: ft.Page):
    page.vertical_alignment = ft.MainAxisAlignment.CENTER
    page.horizontal_alignment = ft.CrossAxisAlignment.CENTER

    page.add(

                ft.Container(height=150, width=300, alignment = ft.alignment.center, bgcolor=ft.Colors.PURPLE_200, content=FletDecimalInput(
                    tooltip="My new FletDecimalInput Control tooltip",
                    value = "My new FletDecimalInput Flet Control", 
                ),),

    )


ft.app(main)
```

## Classes

[FletDecimalInput](FletDecimalInput.md)


