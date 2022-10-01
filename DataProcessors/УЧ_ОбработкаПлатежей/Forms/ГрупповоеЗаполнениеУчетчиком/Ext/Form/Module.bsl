﻿
&НаКлиенте
Процедура Ок(Команда)
	
	Сообщение = "";
	Если Не ПроверитьЗаполнениеСубконто(Сообщение) Тогда
		Ответ = Вопрос(Сообщение + " Вы уверены, что хотите продолжить?", РежимДиалогаВопрос.ДаНет);
		Если Ответ = КодВозвратаДиалога.Нет Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(КорСчет) Тогда
		Предупреждение("Не заполнен корр. счет!");
		Возврат;
	ИначеЕсли Не ЗначениеЗаполнено(КорСубконто1) Тогда 
		Предупреждение("Не заполнен корр. субконто1!");
		Возврат;
	КонецЕсли;	
	
	СтруктураВозврата = новый Структура;
	СтруктураВозврата.Вставить("КорСчет", КорСчет);
	СтруктураВозврата.Вставить("Подразделение", Подразделение);
	СтруктураВозврата.Вставить("КорСубконто1", КорСубконто1);
	Если ЗначениеЗаполнено(КорСубконто2) Тогда 
		СтруктураВозврата.Вставить("КорСубконто2", КорСубконто2);
	КонецЕсли;
	Если ЗначениеЗаполнено(КорСубконто3) Тогда
		СтруктураВозврата.Вставить("КорСубконто3", КорСубконто3);
	КонецЕсли;
	
	ЭтаФорма.Закрыть(СтруктураВозврата);
	
КонецПроцедуры

&НаСервере
Функция ПроверитьЗаполнениеСубконто(Сообщение)
	
	Если КорСчет.ВидыСубконто.Количество() > 1 Тогда
		
		Если КорСчет.ВидыСубконто[1].ВидСубконто = ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Договоры", Истина) И Не ЗначениеЗаполнено(КорСубконто2) Тогда
			Сообщение = "Не заполнен договор.";
			Возврат Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура ПодразделениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
		
	СтандартнаяОбработка = Ложь;

	ФормаВыб = ПолучитьФорму("Справочник.СтруктураПредприятия.ФормаВыбора", , Элемент);
	НовыйОтбор = ФормаВыб.Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	НовыйОтбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Владелец");
	НовыйОтбор.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	НовыйОтбор.ПравоеЗначение = ЭтаФорма.ВладелецФормы.Объект.Предприятие;
	
	ФормаВыб.Открыть();
	
КонецПроцедуры
