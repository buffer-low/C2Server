#ifndef _WINSOCK_DEPRECATED_NO_WARNINGS
#define _WINSOCK_DEPRECATED_NO_WARNINGS 
#endif

#pragma comment(lib, "Ws2_32.lib")
#include <Winsock2.h>
#include <windows.h>
#include <stdio.h>	

int main(int argc, char* argv[]) {
	WORD wVersionRequested = MAKEWORD(2,2);	
	WSADATA wsaData;
	if (WSAStartup(wVersionRequested, &wsaData) < 0) {
		printf("WSAStartup error\n");
	}
	SOCKET s = WSASocketA(2, 1, 6, 0, 0, 0);
	struct sockaddr_in addr;
	addr.sin_family = AF_INET;
	addr.sin_port = htons(9999);
	*(DWORD*)&addr.sin_addr = inet_addr("127.0.0.1");
	bind(s, (struct sockaddr*)&addr, 16);
	while (1) {
		listen(s, 1);
		SOCKET client;
		struct sockaddr_in client_addr;
		int socklen = 16;
		client = accept(s, (struct sockaddr *)&client_addr, &socklen);
		printf("[+] Client %s:%d connected\n", inet_ntoa(client_addr.sin_addr), ntohs(client_addr.sin_port));
		while (1) {
			char buffer[1000];
			scanf("%999s", buffer);
			buffer[999] = 0;
			int len = strlen(buffer);
			buffer[len] = '\n';
			send(client, buffer, strlen(buffer) + 1, 0);
		}
	}
}