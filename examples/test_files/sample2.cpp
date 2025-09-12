#include "sample1.h"

void GlobalFunction() {
    static constexpr auto $break = Constants.Break;
    static constexpr auto $continue = Constants.Continue;
    static constexpr auto any = Constants.Any;
    
    // Test mixed patterns
    if (something) {
        static constexpr auto $break {Constants.Break};
        return $break;
    }
    
    // This should NOT be changed (parameter)
    auto someOtherVariable = SomeClass.SomeValue;
}

class AnotherClass {
private:
    void PrivateMethod() {
        static constexpr auto any {Constants.Any};
        // Process with any
    }
};