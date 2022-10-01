﻿
&НаСервере
Процедура УУ_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	Группа = Элементы.Добавить(
	ЭтаФорма,
	Тип("ГруппаФормы"),
	ЭтаФорма);
	
	Группа.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	Группа.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
	
	Группа.Заголовок = "Параметры для учета (Упр.):";
	
	ПолеВвода = Элементы.Добавить("упрДоход", Тип("ПолеФормы"), Группа);
	ПолеВвода.Вид = ВидПоляФормы.ПолеФлажка;
	ПолеВвода.ПутьКДанным = "Объект.Доход";
    
	ПолеВвода = Элементы.Добавить("упрВидДеятельности", Тип("ПолеФормы"), Группа);
	ПолеВвода.Вид = ВидПоляФормы.ПолеВвода;
	ПолеВвода.ПутьКДанным = "Объект.ВидДеятельности";
	
	ПолеВвода = Элементы.Добавить("упрОбратнаяСтатьяВНХ", Тип("ПолеФормы"), Группа);
	ПолеВвода.Вид = ВидПоляФормы.ПолеВвода;
	ПолеВвода.ПутьКДанным = "Объект.ОбратнаяСтатьяВНХ";
	
	ПолеВвода = Элементы.Добавить("упрСтатьяЗатрат", Тип("ПолеФормы"), Группа);
	ПолеВвода.Вид = ВидПоляФормы.ПолеВвода;
	ПолеВвода.ПутьКДанным = "Объект.СтатьяЗатрат";
	
	ПолеВвода = Элементы.Добавить("упрСчетУчета", Тип("ПолеФормы"), Группа);
	ПолеВвода.Вид = ВидПоляФормы.ПолеВвода;
	ПолеВвода.ПутьКДанным = "Объект.СчетУчета";
	
	ПолеВвода = Элементы.Добавить("упрОписание", Тип("ПолеФормы"), Группа);
	ПолеВвода.Вид = ВидПоляФормы.ПолеВвода;
	ПолеВвода.ПутьКДанным = "Объект.Описание";

КонецПроцедуры
