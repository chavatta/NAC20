riando Usuário com IF #
clear
echo -e "Escolha uma das opções\n1 - Criar usuário\n2 - Alterar Senha\n3 - Sair"
read NUM
case $NUM in
	# Criar usuário
	1)
	echo "Digite o usuáio"
	read USER
	useradd $USER
	test -z $USER || echo "Usuário $USER criado." || exit
	# valid
	RESP=$(getent passwd | grep $USER)
	test -z $RESP
	if [ $? -eq 0 ]; then
		echo "Usuário não existe"
		exit
	else
		echo "Digite a senha"
		read PASS
	fi
	COUNT=$(echo $PASS | wc -c)
	if [ $COUNT -lt 7 ]; then
		echo "Senha invalida"
		exit
	else
		echo -e "$PASS\n$PASS\n" | passwd $USER
	fi
	clear ; echo "Usuáio $USER criado com sucesso";
	;;
	# Alterar Senha
	2)
	clear
	echo "Digite o usuário que deseja alterar a senha"
	read USER
	RESP=$(getent passwd | grep $USER)
	test -z $RESP
	if [ $? -eq 0 ]; then
		echo "Usuário não exite"
		exit
	else
		echo "Digite a nova senha"
		read PASS
	fi
	COUNT=$(echo $PASS | wc -c)
	if [ $COUNT -lt 7 ]; then
		echo "Senha Invalida"
		exit
	else
		echo -e "$PASS\n$PASS\n" | passwd $USER
	fi
	clear ; echo "Senha alterada";
	;;
3)
	exit;
	;;
*)
	echo "Comando Invalido";
	;;
	esac
