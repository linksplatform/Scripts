#pragma once

namespace Test {
    class SampleClass {
    public:
        void Method1() {
            static constexpr auto $break = Constants.Break;
            static constexpr auto $continue = Constants.Continue;
            static constexpr auto any = Constants.Any;
            
            // Some code using these variables
            if (condition) {
                return $break;
            }
            return $continue;
        }
        
        void Method2() {
            static constexpr auto $break {Constants.Break};
            static constexpr auto $continue {Constants.Continue};
            static constexpr auto any {Constants.Any};
            
            // More code
        }
    };
}