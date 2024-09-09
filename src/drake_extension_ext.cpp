#include <nanobind/nanobind.h>
#include <drake/systems/framework/leaf_system.h>

namespace nb = nanobind;
using namespace nb::literals;

NB_MODULE(drake_extension_ext, m) {
  m.doc() = "Example module interfacing with Drake C++";

  using T = double;

  nb::class_<SimpleAdder<T>, LeafSystem<T>>(m, "SimpleAdder")
      .def(nb::init<T>(), nb::arg("add"));
}
