import * as React from 'react';

import { StyleSheet, View } from 'react-native';
import { AnotherKeyboardAvoidingViewView } from 'react-native-another-keyboard-avoiding-view';
import { WebView } from 'react-native-webview';

// function NonWebViewContent() {
//   return (
//     <>
//       <View style={{ padding: 30, width: '100%', alignItems: 'center' }}>
//         <TextInput
//           placeholder="Input"
//           style={{
//             width: '100%',
//             borderWidth: 1,
//             borderColor: '#000',
//             padding: 4,
//           }}
//         ></TextInput>
//       </View>
//       <Text>Low text at keyboard</Text>
//     </>
//   );
// }

export default function App() {
  return (
    <View style={{ flex: 1 }}>
      <AnotherKeyboardAvoidingViewView style={styles.container}>
        {/* <NonWebViewContent /> */}
        <WebView
          style={{ flex: 1 }}
          source={{ uri: 'https://next.zenpay.org' }}
        />
      </AnotherKeyboardAvoidingViewView>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
