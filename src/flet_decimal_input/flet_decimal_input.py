from decimal import Decimal
from enum import Enum
from typing import Any, Optional

from flet.core.types import TextAlign
from flet.core.textfield import TextField
from flet.core.form_field_control import InputBorder
from flet.core.control import OptionalNumber, OptionalControlEventCallable
from flet.core.control_event import ControlEvent
from flet.core.event_handler import EventHandler


class FletDecimalInput(TextField):

    def __init__(self, *args, **kwargs):
        value = kwargs.pop('value', Decimal(0.0))
        super().__init__(*args, **kwargs)
        self.value = value
        self.text_align = kwargs.get('text_align', TextAlign.START)

    def _get_control_name(self):
        return "flet_decimal_input"

    @property
    def value(self) -> Optional[Decimal]:
        try:
            return Decimal(self._get_attr("value"))
        except Exception as e:
            return Decimal(0.0)

    @value.setter
    def value(self, val: Optional[Decimal] = Decimal(0.0)):
        if val is not None:
            self._set_attr("value", float(val))

    @property
    def text_align(self) -> Optional[TextAlign]:
        return TextAlign(self._get_attr("text_align"))

    @text_align.setter
    def text_align(self, val: Optional[TextAlign] = TextAlign.START):
        if val:
            self._set_attr("text_align", val.value)
