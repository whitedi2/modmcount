﻿Функция ПолучитьРегионСтрокой(Адрес) Экспорт 
	
	Если Не ЗначениеЗаполнено(Адрес) Тогда
		Возврат "";
	Иначе
		Возврат РаботаСАдресами.РегионАдресаКонтактнойИнформации(УправлениеКонтактнойИнформацией.КонтактнаяИнформацияПоПредставлению(Адрес,
		Перечисления.ТипыКонтактнойИнформации.Адрес)); 
	КонецЕсли;
	
КонецФункции

Функция ПолучитьГородСтрокой(Адрес) Экспорт 
	
	Если Не ЗначениеЗаполнено(Адрес) Тогда
		Возврат "";
	Иначе
		Возврат РаботаСАдресами.ГородАдресаКонтактнойИнформации(УправлениеКонтактнойИнформацией.КонтактнаяИнформацияПоПредставлению(Адрес,
		Перечисления.ТипыКонтактнойИнформации.Адрес)); 
	КонецЕсли;
	
КонецФункции