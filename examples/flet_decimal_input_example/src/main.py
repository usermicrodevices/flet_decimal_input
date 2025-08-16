from decimal import Decimal

import flet as ft, logging

from flet_decimal_input import FletDecimalInput


logging.basicConfig(level=logging.DEBUG)
#logging.getLogger("flet_core").setLevel(logging.INFO)

def main(page: ft.Page):
    page.vertical_alignment = ft.MainAxisAlignment.CENTER
    page.horizontal_alignment = ft.CrossAxisAlignment.CENTER

    def on_change_decimal(evt: ft.ControlEvent):
        logging.info(['ON_CHANGE_DECIMAL', evt])

    decimal_input = FletDecimalInput(
        tooltip = "FletDecimalInput Control tooltip",
        value = Decimal(10.654),
        text_align = ft.TextAlign.RIGHT,
        on_change = on_change_decimal
    )
    logging.info(decimal_input)

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
