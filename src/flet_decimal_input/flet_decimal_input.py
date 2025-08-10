from decimal import Decimal
from enum import Enum
from typing import Any, Optional

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
            data=data,
            left=left,
            top=top,
            right=right,
            bottom=bottom,
        )

        self.value = value

    def _get_control_name(self):
        return "flet_decimal_input"

    @property
    def value(self) -> Optional[Decimal]:
        return self._get_attr("value")

    @value.setter
    def value(self, value: Optional[Decimal]):
        self._set_attr("value", value)
