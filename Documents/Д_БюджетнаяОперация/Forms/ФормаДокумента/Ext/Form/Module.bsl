﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	//Отказ = БюджетныйНаКлиенте.ПриОткрытииДокумента(ЭтаФорма.Элементы, Объект, ЭтаФорма);		 
	Для каждого СтрокаНабора Из Объект.Движения.Бюджетный Цикл
		
		Если БюджетныйНаСервере.ВернутьРеквизит(СтрокаНабора.СчетДт, "Количественный") Тогда
			СтрокаНабора.Количество = СтрокаНабора.КоличествоДт;	
			СтрокаНабора.КоличествоКРХ = СтрокаНабора.КоличествоКРХДт;
		КонецЕсли; 
		Если БюджетныйНаСервере.ВернутьРеквизит(СтрокаНабора.СчетКт, "Количественный") Тогда
			СтрокаНабора.Количество = СтрокаНабора.КоличествоКт;	
			СтрокаНабора.КоличествоКРХ = СтрокаНабора.КоличествоКРХКт;
		КонецЕсли; 
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	Объект.Дата = НачалоМесяца(Объект.Дата);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Если Модифицированность Тогда
		Для каждого СтрокаНабора Из Объект.Движения.Бюджетный Цикл
			СтрокаНабора.Период = Объект.Дата;
			Если БюджетныйНаСервере.ВернутьРеквизит(СтрокаНабора.СчетДт, "Количественный") Тогда
				СтрокаНабора.КоличествоДт = СтрокаНабора.Количество;
				СтрокаНабора.КоличествоКРХДт = СтрокаНабора.КоличествоКРХ;
			КонецЕсли; 
			Если БюджетныйНаСервере.ВернутьРеквизит(СтрокаНабора.СчетКт, "Количественный") Тогда
				СтрокаНабора.КоличествоКт = СтрокаНабора.Количество;
				СтрокаНабора.КоличествоКРХКт = СтрокаНабора.КоличествоКРХ;
			КонецЕсли; 
			СтрокаНабора.СценарийПлана = Объект.Сценарий;
			СтрокаНабора.Предприятия = Объект.Предприятие;
		КонецЦикла; 
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	//Документы.ГД_Движения.СоздатьДокумент().Скопировать()
КонецПроцедуры


