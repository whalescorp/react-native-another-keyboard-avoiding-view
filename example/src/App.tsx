import * as React from 'react';

import { TextInput, Text, SafeAreaView } from 'react-native';
import { AnotherKeyboardAvoidingView } from 'react-native-another-keyboard-avoiding-view';
import { WebView } from 'react-native-webview';

export default function App() {
  return (
    <SafeAreaView style={{ flex: 1 }}>
      <AnotherKeyboardAvoidingView style={{ flex: 1 }}>
        <WebView
          style={{ flex: 1 }}
          source={{ uri: 'https://next.zenpay.org' }}
        />
        <Text>Low text at keyboard</Text>
        <TextInput
          placeholder="Input"
          style={{
            width: '100%',
            borderWidth: 1,
            borderColor: '#000',
            padding: 4,
          }}
        />
      </AnotherKeyboardAvoidingView>
    </SafeAreaView>
  );
}
