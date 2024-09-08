import numpy as np
from drake_extension import SimpleAdder

from pydrake.systems.analysis import Simulator
from pydrake.systems.framework import (
    DiagramBuilder,
)
from pydrake.systems.primitives import (
    ConstantVectorSource,
    VectorLogSink,
)


def test_custom_system():
    builder = DiagramBuilder()
    source = builder.AddSystem(ConstantVectorSource([10.]))
    adder = builder.AddSystem(drake_extension.SimpleAdder(100.))
    builder.Connect(source.get_output_port(0), adder.get_input_port(0))
    logger = builder.AddSystem(VectorLogSink(1))
    builder.Connect(adder.get_output_port(0), logger.get_input_port(0))
    diagram = builder.Build()

    simulator = Simulator(diagram)
    simulator.AdvanceTo(1)

    x = logger.FindLog(simulator.get_context()).data()
    print("Output values: {}".format(x))
    assert np.allclose(x, 110.)
