import flet as ft, logging

from flet_decimal_input import FletDecimalInput


logging.basicConfig(level=logging.DEBUG)
#logging.getLogger("flet_core").setLevel(logging.INFO)

def main(page: ft.Page):
    page.vertical_alignment = ft.MainAxisAlignment.CENTER
    page.horizontal_alignment = ft.CrossAxisAlignment.CENTER

    decimal_input = FletDecimalInput(
        tooltip="FletDecimalInput Control tooltip",
        value = 10.654,
        #animate=ft.Animation(1000, "bounceOut"),
        #on_animation_end=lambda e: print("Container animation end:", e.data, '; VALUE = ', e.control.value)
    )

    page.add(
        ft.Container(height=150, width=300,
            alignment=ft.alignment.center,
            bgcolor=ft.Colors.GREEN_200,
            content=decimal_input
        ),
    )

    def on_keyboard(evt: ft.KeyboardEvent):
        logging.info(decimal_input.value)
        match evt.key:
            case 'Escape':
                logging.info(evt)
            case _:
                logging.debug(evt)
    page.on_keyboard_event = on_keyboard


ft.app(main)
