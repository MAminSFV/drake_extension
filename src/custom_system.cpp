#include <drake/systems/framework/leaf_system.h>

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
