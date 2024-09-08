#include <nanobind/nanobind.h>
#include <drake/systems/framework/leaf_system.h>

namespace nb = nanobind;
using namespace nb::literals;

using drake::systems::BasicVector;
using drake::systems::Context;
using drake::systems::LeafSystem;
using drake::systems::kVectorValued;

/// Adds a constant to an input.
template <typename T>
class SimpleAdder : public LeafSystem<T> {
 public:
  explicit SimpleAdder(T add)
      : add_(add) {
    this->DeclareInputPort("in", kVectorValued, 1);
    this->DeclareVectorOutputPort(
        "out", BasicVector<T>(1), &SimpleAdder::CalcOutput);
  }

 private:
  void CalcOutput(const Context<T>& context, BasicVector<T>* output) const {
    auto u = this->get_input_port(0).Eval(context);
    auto&& y = output->get_mutable_value();
    y.array() = u.array() + add_;
  }

  const T add_{};
};

NB_MODULE(custom_system, m) {
  m.doc() = "Example module interfacing with pydrake and Drake C++";

  nb::module_ m = nb::module_::import_("pydrake.systems.framework");

  using T = double;

  nb::class_<SimpleAdder<T>, LeafSystem<T>>(m, "SimpleAdder")
      .def(nb::init<T>(), nb::arg("add"));
}
