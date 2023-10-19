﻿
&ИзменениеИКонтроль("ИндексТиповСвязанныхОбъектов")
Функция УУ_ИндексТиповСвязанныхОбъектов()

	Индекс = Новый Соответствие;

	МетаданныеСвязанныхОбъектов = Метаданные.КритерииОтбора.СвязанныеДокументы;
	ТипыСвязанныхОбъектов = МетаданныеСвязанныхОбъектов.Тип.Типы();
	ТипПараметраКоманды = Метаданные.ОбщиеКоманды.СвязанныеДокументы.ТипПараметраКоманды;
	Для Каждого ТипСвязанногоОбъекта Из ТипыСвязанныхОбъектов Цикл 
		Если Не ТипПараметраКоманды.СодержитТип(ТипСвязанногоОбъекта) Тогда 
			Индекс.Вставить(ТипСвязанногоОбъекта, Истина);
		КонецЕсли;
	КонецЦикла;

   	#Вставка  
	МетаданныеСвязанныхОбъектов = Метаданные.КритерииОтбора.саб_СвязанныеДокументы;
	ТипыСвязанныхОбъектов = МетаданныеСвязанныхОбъектов.Тип.Типы();
	ТипПараметраКоманды = Метаданные.ОбщиеКоманды.СвязанныеДокументы.ТипПараметраКоманды;
		Для Каждого ТипСвязанногоОбъекта Из ТипыСвязанныхОбъектов Цикл 
			Если Не ТипПараметраКоманды.СодержитТип(ТипСвязанногоОбъекта) Тогда 
			Индекс.Вставить(ТипСвязанногоОбъекта, Истина);
		КонецЕсли;
		КонецЦикла;  
	#КонецВставки

	Возврат Индекс;

КонецФункции
