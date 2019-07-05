     //
//  main.cpp
//  my_push_server
//
//  Created by luoning on 14-11-4.
//  Copyright (c) 2014年 luoning. All rights reserved.
//

#include <iostream>
#include "push_app.h"
#include "timer/Timer.hpp"
#include <sys/signal.h>

void writePid()
{
    uint32_t curPid;
#ifdef _WIN32
    curPid = (uint32_t) GetCurrentProcess();
#else
    curPid = (uint32_t) getpid();
#endif
    FILE* f = fopen("server.pid", "w");
    assert(f);
    char szPid[32];
    snprintf(szPid, sizeof(szPid), "%d", curPid);
    fwrite(szPid, strlen(szPid), 1, f);
    fclose(f);
}

// {add by chenqw
void daemonize(void) {
	int fd;

	if (fork() != 0)
	{
		exit(0);
	}

	setsid();

	if ((fd = open("/dev/null", O_RDWR, 0)) != -1)
	{
		dup2(fd, STDIN_FILENO);
		dup2(fd, STDOUT_FILENO);
		dup2(fd, STDERR_FILENO);
		if (fd > STDERR_FILENO)
		{
			close(fd);
		}
	}
}
// }

int main(int argc, const char * argv[]) {
    // insert code here...
    printf("start push server...\n");
    signal(SIGPIPE, SIG_IGN);

	// {add by chenqw for linux
	if ((argc == 2) && (strcmp(argv[1], "-d") == 0))
	{
		signal(SIGINT, SIG_IGN);
		signal(SIGQUIT, SIG_IGN);
		daemonize();
	}
	// }

    CPushApp::GetInstance()->Init();
    CPushApp::GetInstance()->Start();
    writePid();
    while (true) {
        S_Sleep(1000);
    }
    return 0;
}
