from decimal import Decimal
from enum import Enum
from typing import Any, Optional

from flet.core.types import TextAlign
from flet.core.textfield import TextField
from flet.core.constrained_control import ConstrainedControl
from flet.core.control import OptionalNumber

class FletDecimalInput(ConstrainedControl):
    """
    FletDecimalInput Control description.
    """

    def __init__(
        self,
        #
        # Control
        #
        opacity: OptionalNumber = None,
        tooltip: Optional[str] = None,
        visible: Optional[bool] = None,
        expand: Optional[Any] = None,
        content_padding: OptionalNumber = None,
        text_align: Optional[TextAlign] = TextAlign.START,
        #text_align: Optional[str] = TextAlign.START,
        data: Any = None,
        #
        # ConstrainedControl
        #
        left: OptionalNumber = None,
        top: OptionalNumber = None,
        right: OptionalNumber = None,
        bottom: OptionalNumber = None,
        #
        # FletDecimalInput specific
        #
        value: Optional[Decimal] = 0.0,
    ):
        ConstrainedControl.__init__(
            self,
            tooltip=tooltip,
            opacity=opacity,
            visible=visible,
            expand=expand,
            data=data,
            left=left,
            top=top,
            right=right,
            bottom=bottom,
        )

        self.value = value
        self.text_align = text_align
        self.content_padding = content_padding

    def _get_control_name(self):
        return "flet_decimal_input"

    @property
    def child_id(self) -> Optional[str]:
        return self._get_attr("child_id")

    @property
    def child_key(self) -> Optional[str]:
        return self._get_attr("child_key")

    @property
    def value(self) -> Optional[Decimal]:
        return self._get_attr("value")

    @value.setter
    def value(self, val: Optional[Decimal]):
        self._set_attr("value", val)

    @property
    def text_align(self) -> Optional[TextAlign]:
        return TextAlign(self._get_attr("text_align"))

    @text_align.setter
    def text_align(self, val: Optional[TextAlign]):
        self._set_attr("text_align", val.value)
