import codegenNativeComponent from 'react-native/Libraries/Utilities/codegenNativeComponent';
import type { ViewProps } from 'react-native';

interface NativeProps extends ViewProps {
  enabled?: boolean;
}

export default codegenNativeComponent<NativeProps>(
  'AnotherKeyboardAvoidingView'
);
