#!/bin/bash
# Gerenciador de usuários #
# Comandos base		  #
#############################
clear
cd ~
mkdir Relatorios
DONE="1"
clear
while [ $DONE != "0" ]
do
echo -e "Escolha uma das opções\n1 - Criar usuário\n2 - Alterar Senha\n3 - Deletar usuário\n4 - Criar grupo\n5 - Adicionar usuário a grupo\n6 - Excluir grupo\n7 - Relação de usuários\n8 - Sair"
read NUM
case $NUM in
	# Criar usuário
	1)
		clear
		echo "`date -u` - Digite o usuário que deseja que seja criado"
		read USER
		RESP=$(getent passwd | grep $USER)
		test -z $RESP
		if [ $? -eq 1 ]; then
			echo "`date -u` - O Usuário $USER já existe"
			exit
		else
			useradd $USER
			echo "`date -u` - Digite a senha"
			read PASS
		fi
		COUNT=$(echo $PASS | wc -c)
		if [ $COUNT -lt 7 ]; then
			echo "`date -u` - Senha Invalida"
			exit
		else
			echo -e "$PASS\n$PASS\n" | passwd $USER
		fi
		clear ; echo "`date -u` - Senha alterada";
		DONE="0"
	;;
	# Alterar Senha
	2)
		clear
		echo "`date -u` - Digite o usuário que deseja alterar a senha"
		read USER
		RESP=$(getent passwd | grep $USER)
		test -z $RESP
		if [ $? -eq 0 ]; then
			echo "`date -u` - O usuário $USER não exite"
			exit
		else
			echo "`date -u` - Digite a nova senha"
			read PASS
		fi
		COUNT=$(echo $PASS | wc -c)
		if [ $COUNT -lt 7 ]; then
			echo "`date -u` - Senha Invalida"
			exit
		else
			echo -e "$PASS\n$PASS\n" | passwd $USER
		fi
		clear ; echo "`date -u` - Senha alterada";
		DONE=0
	;;
	# Deletar Usuário
	3)
		clear
		echo "`Date -u` - Digite o usuário que deseja deletar"
		read USER
		RESP=$(getent passwd | grep $USER)
		test -z $RESP
		if [ $? -eq 0 ]; then
			echo "`date -u` - O usuário $USER não exite"
			exit
		else
			deluser $USER
		fi
		clear ; echo "`date -u` - O usuáio $USER foi deletado";
		DONE=0
	;;
	#Criar Grupo
	4)
		clear
		echo "`date -u` - Digite o nome do grupo"
		read GROUP
		RESP=$(cut -d: -f1 /etc/group | grep $GROUP)
		test -z $RESP
		if [ $? -eq 1 ]; then
			echo "`date -u` - O Grupo $GROUP já existe"
			exit
		else
			addgroup $GROUP
		fi
		clear ; echo "`date -u` - Usuário $GROUP criado com sucesso";
		DONE=0
	;;
	#Adicionar usuário ao grupo
	5)
		clear
		echo "`date -u ` - Digite o usuário que você deseja alterar"
		read USER
		VALID_USER=$(getent passwd | grep $USER)
		test -z $VALID_USER
		if [ $? -eq 0 ]; then
			echo "`date -u` - O usuário $USER  não existe"
			exit
		else
			echo "`date -ù` - Digite o grupo que deseja adicionar o usuário $USER"
			read GROUP
			VALID_GROUP=$(cut -d: -f1 /etc/group | grep $GROUP)
			test -z $VALID_GROUP
			if [ $? -eq 0 ]; then
				echo "`date -u` - O Grupo $GROUP é um grupo invalido"
				exit
			else
				usermod -a -G $GROUP $USER
			fi
		fi
		clear ; echo "`date -u` - O usuário $USER foi adiconado ao grupo $GROUP.";
		DONE=0
	;;
	#Excluir Grupos
	6)
		clear
		echo "`date -u` - Digite qual grupo você deseja excluir"
		read GROUP
		VALID_GROUP=$(cut -d: -f1 /etc/group | grep $GROUP)
		test -z $VALID_GROUP
		if [ $? -eq 0 ]; then
			echo "`date -u` - O Grupo $GROUP não existe"
			exit
		else
			groupdel $GROUP
		fi
		clear ; echo "`date -u` - O Grupo $GROUP foi excluido.";
		DONE=0
	;;
	#Relatorio de usuários
	7)
		clear
		cd ~
		cd Relatorios
		DONE1="1"
		clear
		while [ $DONE1 != "0" ]
		do
			echo -e "Selecione qual relatorio você deseja\n1 - Relatorio simplificado\n2 - Relatorio completo\n0 - Exit"
			read OPT
			case $OPT in
				1)
					cut -d: -f1 /etc/passwd >> Relatorio_Usuarios_Simplificado.txt
					DONE1="0";
					;;
				2)	cat /etc/passwd >> Relatorio_usuarios_completo
					DONE1="0";
					;;
				0)
					exit
					DONE1="0";
					;;
				*)
					echo"`date -u` - Opção incorreta selecione novamente"
					DONE1="1";
					;;
			esac
		done
		echo "`date -u` - A lista de usuários foi gerada no diretorio de Relatorios";
		DONE=0
	;;	
	#EXIT
	8)
	exit;
	DONE=0
	;;
	*)
		echo "`date -u` - Comando Invalido";
		DONE=1
	;;
	esac
done
exit 0 
