
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если Строка(КомпоновщикНастроек.Настройки.Выбор.Элементы[0].Поле) = "Сумма1" Тогда
		
		Если КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[2].Значение = Справочники.СценарииПланирования.Факт Тогда
			СценарийБюджетный1 = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[1].Значение;
			СценарийБюджетный2 = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[1].Значение;
		ИначеЕсли КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[1].Значение = Справочники.СценарииПланирования.Факт Тогда
			СценарийБюджетный1 = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[2].Значение;
			СценарийБюджетный2 = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[2].Значение;
		Иначе
			СценарийБюджетный1 = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[1].Значение;
			СценарийБюджетный2 = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[2].Значение;
		КонецЕсли;
		
		СхемаКомпоновкиДанных.Параметры.СценарийБюджетный1.Значение = СценарийБюджетный1;
		СхемаКомпоновкиДанных.Параметры.СценарийБюджетный2.Значение = СценарийБюджетный2;
				
		Если КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[1].Значение = Справочники.СценарииПланирования.Факт ИЛИ
			КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[2].Значение = Справочники.СценарииПланирования.Факт Тогда
			ЕстьФакт = Истина;
		Иначе
			ЕстьФакт = Ложь;
		КонецЕсли;	
		СхемаКомпоновкиДанных.Параметры.ЕстьФакт.Значение = ЕстьФакт;
		
	КонецЕсли;	
	
КонецПроцедуры
